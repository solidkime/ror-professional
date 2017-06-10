# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, except: [:index, :show, :new], shallow: true do
      put :mark_best, on: :member
    end
  end
  resources :attachments, only: :destroy
  
  root to: "questions#index"
end
