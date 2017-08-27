--自由引领者·祈祷的琳
function c10131008.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,true)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),4,2)
	c:EnableReviveLimit()
	--pset
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10131008,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(c10131008.descon)
	e1:SetTarget(c10131008.destg)
	e1:SetOperation(c10131008.desop)
	c:RegisterEffect(e1)  
	--psset
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetDescription(aux.Stringid(10131008,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,10131008)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c10131008.settg)
	e2:SetOperation(c10131008.setop)
	c:RegisterEffect(e2) 
end
c10131008.pendulum_level=4
function c10131008.pcfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA)) and c:IsSetCard(0x5338)
end
function c10131008.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7))
		and Duel.IsExistingMatchingCard(c10131008.pcfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
end
function c10131008.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c10131008.pcfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil):GetFirst()
	if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
	   local op,ll=0,0
	   Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10131008,5))
	   if tc:GetRightScale()==9 then
		  op=Duel.SelectOption(tp,aux.Stringid(10131008,2))
	   elseif tc:GetRightScale()==1 then 
		  op=Duel.SelectOption(tp,aux.Stringid(10131008,3))+1
	   else 
		  op=Duel.SelectOption(tp,aux.Stringid(10131008,2),aux.Stringid(10131008,3))
	   end
	   if op==0 then ll=1 else ll=9 end
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_CHANGE_LSCALE)
	   e1:SetValue(ll)
	   e1:SetReset(RESET_EVENT+0x1fe0000)
	   tc:RegisterEffect(e1)
	   local e2=e1:Clone()
	   e2:SetCode(EFFECT_CHANGE_RSCALE)
	   tc:RegisterEffect(e2)
	   if c:IsRelateToEffect(e) and c:IsFaceup() and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(10131008,4)) then
		  Duel.BreakEffect()
		  c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		  local e1=Effect.CreateEffect(c)
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetCode(EFFECT_UPDATE_ATTACK)
		  e1:SetValue(600)
		  e1:SetReset(RESET_EVENT+0x1ff0000)
		  c:RegisterEffect(e1)
	   end
	end
end
function c10131008.filter(c,tp,ep)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and ep~=tp 
end
function c10131008.descon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c10131008.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tg=eg:Clone():AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,2,0,0)
end
function c10131008.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Clone():AddCard(e:GetHandler())
	if e:GetHandler():IsRelateToEffect(e) then
	   Duel.NegateSummon(eg)
	   Duel.Destroy(tg,REASON_EFFECT)
	end
end