json.data do
  json.array! @users, partial: 'show', as: :user
end
