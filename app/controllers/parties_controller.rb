class PartiesController < ApplicationController
  def index
    uri = PartyQueryObject.all
    response_streamer(uri)
  end

  def lookup
    source = params['source']
    id = params['id']
    uri = PartyQueryObject.lookup(source, id)
    response_streamer(uri)
  end

  def a_z_letters_all
    uri = PartyQueryObject.a_z_letters_all
    response_streamer(uri)
  end

  def current
    uri = PartyQueryObject.all_current
    response_streamer(uri)
  end

  def a_z_letters_current
    uri = PartyQueryObject.a_z_letters_current
    response_streamer(uri)
  end

  def show
    id = params[:party]
    uri = PartyQueryObject.find(id)
    response_streamer(uri)
  end

  def members
    id = params[:party_id]
    uri = PartyQueryObject.members(id)
    response_streamer(uri)
  end

  def current_members
    id = params[:party_id]
    uri = PartyQueryObject.current_members(id)
    response_streamer(uri)
  end

  def letters
    letter = params[:letter]
    uri = PartyQueryObject.all_by_letter(letter)
    response_streamer(uri)
  end

  def members_letters
    letter = params[:letter]
    id = params[:party_id]
    uri = PartyQueryObject.members_by_letter(id, letter)
    response_streamer(uri)
  end

  def a_z_letters_members
    id = params[:party_id]
    uri = PartyQueryObject.a_z_letters_members(id)
    response_streamer(uri)
  end

  def current_members_letters
    letter = params[:letter]
    id = params[:party_id]
    uri = PartyQueryObject.current_members_by_letter(id, letter)
    response_streamer(uri)
  end

  def a_z_letters_members_current
    id = params[:party_id]
    uri = PartyQueryObject.a_z_letters_members_current(id)
    response_streamer(uri)
  end

  def lookup_by_letters
    letters = params[:letters]
    uri = PartyQueryObject.lookup_by_letters(letters)
    response_streamer(uri)
  end
end
