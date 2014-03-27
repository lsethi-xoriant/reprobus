FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

	  factory :admin do
      admin true
    end
  end
  
  factory :tour do
    sequence(:country)  { |n| "Country #{n}" }
    sequence(:tourName) { |n| "Tour_#{n}"}
    sequence(:destination) { |n| "Destination #{n}"}
    sequence(:tourPrice) { |n| 100 + n}
  end
end