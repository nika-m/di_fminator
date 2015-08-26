module ApplicationHelper
  # Borrowed from: http://vinsol.com/blog/2014/02/11/guide-to-caching-in-rails-using-memcache/
  # Calculate the result if key not present and store in Memcache
  # Return calculated result from Memcache if key is present

  def data_cache(key, time=2.minutes)
    return yield if caching_disabled?
    output = Rails.cache.fetch(key, {expires_in: time}) do
      yield
    end
    return output
  rescue
    # Execute the block if any error with Memcache
    return yield
  end

  def caching_disabled?
    ActionController::Base.perform_caching.blank?
  end

  def read_cache(cache_key)
    Rails.cache.read(cache_key)
  end

  def cache_this(cache_key, data, expiration)
    Rails.cache.write(cache_key, data, expires_in: expiration)
  end

  def kill_cache(cache_key)
    Rails.cache.delete(cache_key)
  end
end
