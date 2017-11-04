--アーリン
function c17060913.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pendulum set/spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060913,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,17060913)
	e1:SetTarget(c17060913.rptg)
	e1:SetOperation(c17060913.rpop)
	c:RegisterEffect(e1)
end
c17060913.is_named_with_Waves_Type=1
function c17060913.IsWaves_Type(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Waves_Type
end
function c17060913.rpfilter(c,e,tp)
	return c17060913.IsWaves_Type(c) and not c:IsForbidden()
end
function c17060913.rptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17060913.rpfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c17060913.rpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(17060913,6))
		local g=Duel.SelectMatchingCard(tp,c17060913.rpfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		local op=0
		if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
			op=Duel.SelectOption(tp,aux.Stringid(17060913,1),aux.Stringid(17060913,2))
		else
			op=Duel.SelectOption(tp,aux.Stringid(17060913,2))
		end
		if op==0 then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end