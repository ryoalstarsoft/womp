# https://github.com/resque/resque/issues/1591
Redis::Namespace.class_eval do
	def client
		_client
	end
end


if ENV["REDISCLOUD_URL"]
	$redis = Resque.redis = Redis.new(:url => ENV["REDISCLOUD_URL"])
end
