Spree::Admin::PricesController.class_eval do 
  def update_positions
    ApplicationRecord.transaction do
      params[:positions].each do |id, index|
        Spree::PriceBook.where(id: id).update_all(priority: index)
      end
    end

    respond_to do |format|
      format.html { redirect_to admin_stores_url(params[:store_id]) }
      format.js { render plain: 'Ok' }
    end
  end

  def update
    params[:variant].each_pair do |id, amount_hash|
      next if amount_hash[:amount].blank?
      variant_price(id).update_attributes(amount: amount_hash[:amount])
    end if params[:variant]

    redirect_to return_path
  end

  def create
    params.require(:vp).permit!
    params[:vp].each do |variant_id, prices|
      variant = Spree::Variant.find(variant_id)
      next unless variant

      # Fix prices downcased key. It's upcase in view but downcased after using params. Need to figure out why later
      prices.keys.each { |k| prices[k.upcase] = prices[k]; prices.delete(k) }
      supported_currencies.each do |currency|
        price = variant.price_in(currency.iso_code)
        price.price = (prices[currency.iso_code].blank? ? nil : prices[currency.iso_code])
        price.save! if price.new_record? && price.price || !price.new_record? && price.changed?
      end
    end
    flash[:success] = Spree.t('notice_messages.prices_saved')
    redirect_to admin_product_prices_path(@product)
  end

  protected
  def variant_price(variant_id)
    current_price_book = Spree::PriceBook.find(params[:price_book_id])
    Spree::Price.where(
      variant_id: variant_id,
      price_book_id: current_price_book.id,
      currency: current_price_book.currency
    ).first_or_create
  end

  def return_path
    if !!session[:return_to_price_book]
      session.delete(:return_to_price_book)
      admin_price_book_path(params[:price_book_id])
    else
      session[:current_price_book_id] = params[:price_book_id]
      variant_prices_admin_product_path(params[:product_id])
    end
  end
end