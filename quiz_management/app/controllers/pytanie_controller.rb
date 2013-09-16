# encoding: UTF-8

class PytanieController < ApplicationController
  before_filter :has_quiz_modify_privilege?, :only => [:edit, :update]

  def edit
    id_pytania = params[:id_pyt] || params[:id] || params[:pytanie][:id_pyt]
    @pytanie = Pytanie.find(id_pytania)
    @nowa_odpowiedz = OdpowiedzWzorcowa.new(:id_pyt => id_pytania)
    @nowa_odpowiedz.tresc_odp = 'Nowa odpowiedz'
  end

  def create
    @pytanie = Pytanie.new(params[:pytanie])
    @pytanie.id_autora = session[:user_id]
    @pytanie.save
    redirect_to quiz_edit_url(:id => @pytanie.id_quizu), notice: 'Pytanie zapisane.'
  end

  def update
    @pytanie = Pytanie.find(params[:pytanie][:id_pyt])
    @pytanie.update_attributes(params[:pytanie].except(:id_pyt))
    @pytanie.save
    puts @pytanie.inspect.to_s + "........" + @params.inspect.to_s
    puts @pytanie.errors.inspect
    if @pytanie.errors.any?
      redirect_to pytanie_edit_url(:id => @pytanie.id_pyt), alert: "Pytanie nie zapisane.\n" + @pytanie.errors.full_messages.join("\n")
    else
      redirect_to pytanie_edit_url(:id => @pytanie.id_pyt), notice: 'Pytanie zapisane.'
    end
  end

  def destroy
    @pytanie = Pytanie.find(params[:pytanie][:id_pyt])
    @pytanie.destroy
    redirect_to quiz_edit_url(:id => @pytanie.id_quizu), notice: 'Pytanie usuniete.'
  end

end
