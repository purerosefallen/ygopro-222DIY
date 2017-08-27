--口袋妖怪 素利拍
function c80000165.initial_effect(c)
--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x2d0),aux.NonTuner(nil),1)
	c:EnableReviveLimit() 
	--immune
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetValue(c80000165.efilter)
	c:RegisterEffect(e0)
	--attack up
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetDescription(aux.Stringid(80000165,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetCountLimit(1,80000165)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c80000165.descon)
	e1:SetTarget(c80000165.target)
	e1:SetOperation(c80000165.operation)
	c:RegisterEffect(e1)
	--lv up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000165,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c80000165.con)
	e2:SetHintTiming(0x1c0)
	e2:SetTarget(c80000165.tg)
	e2:SetOperation(c80000165.op)
	c:RegisterEffect(e2)
end
function c80000165.efilter(e,te)
	local c=te:GetHandler()
	return c:IsCode(80000477)
end
function c80000165.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO 
end
function c80000165.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c80000165.filter1(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c80000165.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c80000165.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80000165.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c80000165.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c80000165.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
end
function c80000165.filter(c)
	return (c:IsLevelBelow(6) or c:IsRankBelow(6)) and c:IsControlerCanBeChanged() and c:IsFaceup()
end
function c80000165.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()~=tp and c80000165.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80000165.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c80000165.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c80000165.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not Duel.GetControl(tc,tp) then
		if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end

