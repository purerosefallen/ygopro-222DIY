--3L·雨天的绯想
local m=37564834
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	--Senya.CommonEffect_3L(c,m)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,0))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_HAND)
	e6:SetCountLimit(1,m)
	e6:SetCost(Senya.SelfToGraveCost)
	e6:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
	end)
	e6:SetTarget(cm.target)
	e6:SetOperation(cm.activate)
	c:RegisterEffect(e6)
end
function cm.effect_operation_3L(c)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.cnegcon)
	e3:SetOperation(cm.cnegop)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e3,true)
	return e3
end
function cm.chkfilter_mokou(c)
	return c:GetOriginalCode()==m
end
function cm.NegateEffectWithoutChainingCondition(e,tp,eg,ep,ev,re,r,rp)
	local loc,np=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_CONTROLER)
	return e:GetHandler():GetFlagEffect(m)==0 and re:GetHandler():IsRelateToEffect(re) and not re:GetHandler():IsImmuneToEffect(e) and (loc & 0x0c)~=0 and np~=tp and re:GetHandler():IsAbleToGrave()
end
function cm.NegateEffectWithoutChainingOperation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,m*16+2) then return end
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode())
	e:GetHandler():RegisterFlagEffect(m,0x1fe1000+RESET_PHASE+PHASE_END,0,1)
	Duel.SendtoGrave(re:GetHandler(),REASON_EFFECT)
end
function cm.cfilter(c)
	return c:IsFaceup() and Senya.check_set_3L(c) and c:IsType(TYPE_FUSION)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end