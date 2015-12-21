class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    # if user.admin?
    #   can :manage, :all
    # else
    #   can :read, :all
    # end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    if user.accounts?
      default_abilities
      сan [:manage], SuppliersController
    end

    if user.sales?
      default_abilities
      can [:manage], AgentsController
      can [:manage], EnquiriesController
      cannot [:destroy], EnquiriesController
    end

    if user.admin?
      сan [:manage], Admin::CarriersController
      сan [:manage], Admin::DestinationsController
      сan [:manage], Admin::StopoversController
      сan [:manage], Admin::DashboardController
      сan [:manage], Admin::CountriesController

      сan [:manage], Products::DashboardController
      сan [:manage], Products::ProductsController 

      can [:manage], AgentsController
      can [:manage], ItineraryTemplatesController
      сan [:manage], SearchesController
      сan [:manage], SuppliersController
      can [:show],   UsersController
      can [:manage], StaticPagesController
    end
    if user.management?
      can [:manage], :all
    end
  end

  def default_abilities
    can [:manage], Reports::DashboardController
    can [:manage], Reports::ConfirmedBookingController
    can [:manage], Reports::EnquiryController
    can [:manage], Reports::BookingTravelController

    can [:manage], CustomerInteractionsController

    can [:manage], CustomersController
    cannot [:destroy], CustomersController

    can [:manage], InvoicesController
    cannot [:destroy], InvoicesController

    can [:manage], ItinerariesController
    cannot [:destroy], ItinerariesController

    сan [:manage], ItineraryPricesController
    cannot [:destroy], ItineraryPricesController

    сan [:manage], SearchesController
    can [:show], UsersController
    can [:home, :about, :timed_out, :dashboard, :dashboard_list, :snapshot, 
         :currencysearch, :noaccess], StaticPagesController
  end
end
