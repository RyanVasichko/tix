class NullQueueAdapter
  def self.suppress_queues
    old_queue_adapter = ActiveJob::Base.queue_adapter
    ActiveJob::Base.queue_adapter = self.new
    yield
  ensure
    ActiveJob::Base.queue_adapter = old_queue_adapter
  end

  def enqueue(job, *args) end

  def enqueue_at(job, timestamp, *args) end
end