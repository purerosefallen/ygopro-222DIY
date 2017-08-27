--口袋妖怪 大嘴娃
function c80000202.initial_effect(c)
	c:SetSPSummonOnce(80000202)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x2d0),aux.NonTuner(Card.IsSetCard,0x2d0),1)
	c:EnableReviveLimit()   
	--salvage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80000202,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c80000202.thtg)
	e1:SetOperation(c80000202.thop)
	c:RegisterEffect(e1)
end
function c80000202.filter(c)
	return c:IsSetCard(0x2d0) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c80000202.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c80000202.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80000202.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c80000202.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c80000202.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c80000202.sumlimit)
		e1:SetLabel(tc:GetCode())
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SUMMON)
		Duel.RegisterEffect(e2,tp)
	end
end
function c80000202.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end
