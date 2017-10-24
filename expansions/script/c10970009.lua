--纸上台本 「萤石的时空残影」
function c10970009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)	
	e1:SetTarget(c10970009.atg)
	e1:SetCountLimit(2,10970001+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1) 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c10970009.target)
	e2:SetValue(TYPE_TUNER)
	c:RegisterEffect(e2) 
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10970009,0))
	e5:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_FZONE)
	e5:SetHintTiming(0,0x1c0)
	e5:SetCondition(c10970009.condition)
	e5:SetTarget(c10970009.tgtg)
	e5:SetOperation(c10970009.tgop1)
	c:RegisterEffect(e5) 
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(10970009,0))
	e9:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e9:SetRange(LOCATION_MZONE)
	e9:SetHintTiming(0,0x1c0)
	e9:SetCondition(c10970009.condition2)
	e9:SetTarget(c10970009.tgtg)
	e9:SetOperation(c10970009.tgop2)
	c:RegisterEffect(e9)  
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_ADD_TYPE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTarget(c10970009.target)
	e6:SetCondition(c10970009.condition0)
	e6:SetValue(TYPE_TUNER)
	c:RegisterEffect(e6) 
end
function c10970009.atg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return true end 
   if c10970009.condition(e,tp,eg,ep,ev,re,r,rp,0) and c10970009.tgtg(e,tp,eg,ep,ev,re,r,rp,0)
		and Duel.SelectYesNo(tp,94) then
		c10970009.tgtg(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetOperation(c10970009.tgop1)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c10970009.condition0(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,10970008)
end
function c10970009.filter(c)
	return c:IsFaceup() and c:IsCode(10970002)
end
function c10970009.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10970009.filter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c10970009.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10970009.filter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsPlayerAffectedByEffect(tp,10970008)
end
function c10970009.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) end
	if chk==0 then return Duel.GetFlagEffect(tp,10970009)==0 and Duel.IsExistingTarget(nil,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10970009,2))
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.RegisterFlagEffect(tp,10970009,RESET_PHASE+PHASE_END,0,1)
end
function c10970009.tgop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
	Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c10970009.tgop2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
	Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c10970009.target(e,c)
	return c:IsSetCard(0x1233) and not c:IsSetCard(0x2233)
end

