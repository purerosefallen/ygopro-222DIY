--联合作战
function c16080018.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1) 
	--ChangePosition
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c16080018.target)
	e2:SetOperation(c16080018.activate)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAIN_ACTIVATING)
	e3:SetCondition(c16080018.discon)
	e3:SetOperation(c16080018.disop)
	c:RegisterEffect(e3)
end
function c16080018.filter(c)
	return c:IsFaceup() and not c:IsType(TYPE_LINK)
end
function c16080018.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c16080018.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16080018.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c16080018.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c16080018.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end
function c16080018.disfilter(c)
	return c:IsSetCard(0x5ca) and c:IsFaceup() and c:IsLevelAbove(6)
end
function c16080018.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingTarget(c16080018.disfilter,tp,LOCATION_MZONE,0,2,nil)
end
function c16080018.disop(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if rp==tp then return false 
		else if loc==LOCATION_GRAVE or loc==LOCATION_HAND or loc==LOCATION_DECK or loc==LOCATION_EXTRA or loc==LOCATION_REMOVED then
		Duel.NegateEffect(ev)
		end
	end
end