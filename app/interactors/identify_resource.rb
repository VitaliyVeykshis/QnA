class IdentifyResource
  include Interactor

  def call
    context.resource = resource
  end

  private

  def resource
    context.params.each do |name, value|
      return $1.classify.constantize.find_by(id: value) if name =~ /(.+)_id$/
    end

    nil
  end
end
