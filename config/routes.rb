# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    put :mark_best_answer, on: :member
    resources :answers, except: [:index, :show, :new], shallow: true
  end

  root to: "questions#index"
end
