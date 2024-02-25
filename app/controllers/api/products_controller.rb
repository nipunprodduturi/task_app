# frozen_string_literal: true

module Api
  # This Product controller to handle product related actions
  class ProductsController < ApplicationController
    before_action :authenticate_request
    before_action :set_product, only: %i[update destroy]

    def index
      @products = Product.active.order(created_at: :desc)
      render json: @products
    end

    def search # rubocop:disable Metrics/AbcSize
      validate_search_params

      if params[:min_posted_date].present?
        min_date = DateTime.parse(params[:min_posted_date])
        @products = @products.where('created_at >= ?', min_date)
      end

      if params[:max_posted_date].present?
        max_date = DateTime.parse(params[:max_posted_date])
        @products = @products.where('created_at <= ?', max_date)
      end

      render json: @products
    rescue StandardError => e
      Rails.logger.error("Error parsing date: #{e.message}")
      render json: { error: e.message }, status: :bad_request
    end

    def create
      @product = Product.new(product_params)
      if @product.save
        render json: @product, status: :created
      else
        render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
      end
    rescue StandardError => e
      Rails.logger.error("Error creating product: #{e.message}")
      render json: { error: 'Internal Server Error' }, status: :internal_server_error
    end

    def update
      if @product.update(product_params)
        render json: @product
      else
        render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
      end
    rescue StandardError => e
      Rails.logger.error("Error updating product: #{e.message}")
      render json: { error: 'Internal Server Error' }, status: :internal_server_error
    end

    def destroy
      if @product.destroy
        render json: @product, status: :ok
      else
        render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
      end
    rescue StandardError => e
      Rails.logger.error("Error deleting product: #{e.message}")
      render json: { error: 'Internal Server Error' }, status: :internal_server_error
    end

    private

    def set_product
      @product = Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error("Product not found: #{e.message}")
      render json: { error: 'Product not found' }, status: :not_found
    end

    def product_params
      params.require(:product).permit(:name, :price, :status)
    end

    def validate_search_params # rubocop:disable Metrics/AbcSize
      @products = Product.all

      @products = @products.where('name LIKE ?', "%#{params[:product_name]}%") if params[:product_name].present?

      @products = @products.where('price >= ?', params[:min_price]) if params[:min_price].present?

      @products = @products.where('price <= ?', params[:max_price]) if params[:max_price].present?
    end
  end
end
