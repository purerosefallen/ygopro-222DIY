--真理教会 裁决者
function c2130001.initial_effect(c)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),aux.NonTuner(Card.IsType,TYPE_PENDULUM),1)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2130001,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c2130001.thcon)
	e1:SetOperation(c2130001.tgop1)
	c:RegisterEffect(e1)
end
function c2130001.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO 
end
function c2130001.tgop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(2130001,0)) then
		local g2=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
		Duel.ConfirmCards(tp,g2)
		local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,1,nil)
		local tc=tg:GetFirst()
		local code=tc:GetOriginalCode()
		local reset_flag=RESET_EVENT+0x1fe0000
		c:CopyEffect(code, reset_flag)
		Duel.BreakEffect()
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end