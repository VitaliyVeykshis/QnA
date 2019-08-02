module VotedPolicy
  def vote_up?
    !user.author?(record) if user&.persisted?
  end

  def vote_down?
    vote_up?
  end
end
