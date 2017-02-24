Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'index', to: 'application#index', as: :index

  get '/people/members', to: 'members#index'
  match '/people/:person', to: 'people#show', person: /\w{8}-\w{4}-\w{4}-\w{4}-\w{12}/, via: [:get]
  get '/people/:letter', to: 'people#letters', letter: /[A-Za-z]/, via: [:get]
  get '/people/lookup', to: 'people#lookup'
  get '/people/a_z_letters', to: 'people#a_z_letters'
  get '/people/:letters', to: 'people#lookup_by_letters'

  get '/people/members/current', to: 'members#current'
  match '/people/members/:letter', to: 'members#letters', letter: /[A-Za-z]/, via: [:get]
  match '/people/members/current/:letter', to: 'members#current_letters', letter: /[A-Za-z]/, via: [:get]

  match '/constituencies/:constituency', to: 'constituencies#show', constituency: /\w{8}-\w{4}-\w{4}-\w{4}-\w{12}/, via: [:get]
  match '/constituencies/:letter', to: 'constituencies#letters', letter: /[A-Za-z]/, via: [:get]
  get '/constituencies/current', to: 'constituencies#current'
  get '/constituencies/lookup', to: 'constituencies#lookup'
  get '/constituencies/:letters', to: 'constituencies#lookup_by_letters'
  match '/constituencies/current/:letter', to: 'constituencies#current_letters', letter: /[A-Za-z]/, via: [:get]

  match '/parties/:party', to: 'parties#show', party: /\w{8}-\w{4}-\w{4}-\w{4}-\w{12}/, via: [:get]
  get '/parties/:letter', to: 'parties#letters', letter: /[A-Za-z]/, via: [:get]
  get '/parties/current', to: 'parties#current'
  get '/parties/lookup', to: 'parties#lookup'
  get '/parties/:letters', to: 'parties#lookup_by_letters'

  match '/houses/:house', to: 'houses#show', house: /\w{8}-\w{4}-\w{4}-\w{4}-\w{12}/, via: [:get]
  get '/houses/lookup', to: 'houses#lookup'
  get '/houses/:letters', to: 'houses#lookup_by_letters'

  resources :people, only: [:index] do
    get '/constituencies', to: 'people#constituencies'
    get '/constituencies/current', to: 'people#current_constituency'
    get '/parties', to: 'people#parties'
    get '/parties/current', to: 'people#current_party'
    get '/contact_points',to: 'people#contact_points'
    get '/houses',to: 'people#houses'
    get '/houses/current', to: 'people#current_house'
    get '/sittings', to: 'people#sittings'
  end

  resources :contact_points, only: [:index, :show]

  resources :parties, only: [:index] do
    get '/members', to: 'parties#members'
    get '/members/current', to: 'parties#current_members'
    match '/members/:letter', to: 'parties#members_letters', letter: /[A-Za-z]/, via: [:get]
    match '/members/current/:letter', to: 'parties#current_members_letters', letter: /[A-Za-z]/, via: [:get]
  end

  resources :constituencies, only: [:index] do
    get '/members', to: 'constituencies#members'
    get '/members/current', to: 'constituencies#current_member'
    get '/contact_point', to: 'constituencies#contact_point'
  end

  resources :houses, only: [:index] do
    get '/members', to: 'houses#members'
    get '/members/current', to: 'houses#current_members'
    get '/parties', to: 'houses#parties'
    get '/parties/current', to: 'houses#current_parties'
    get '/parties/:party_id', to: 'houses#party'
    match '/members/:letter', to: 'houses#members_letters', letter: /[A-Za-z]/, via: [:get]
    match '/members/current/:letter', to: 'houses#current_members_letters', letter: /[A-Za-z]/, via: [:get]
    get '/parties/:party_id/members', to: 'houses#party_members'
    match '/parties/:party_id/members/:letter', to: 'houses#party_members_letters', letter: /[A-Za-z]/, via: [:get]
    get '/parties/:party_id/members/current', to: 'houses#current_party_members'
    match '/parties/:party_id/members/current/:letter', to: 'houses#current_party_members_letters', letter: /[A-Za-z]/, via: [:get]
  end
end
