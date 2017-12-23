--元素爆发·冰雪
local m=37564026
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_elem=true
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,nil,5,4,cm.ovfilter,aux.Stringid(m,0))
	c:EnableReviveLimit()
--ctxm
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--rm
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.rmcon)
	e2:SetOperation(cm.rmop)
	c:RegisterEffect(e2)
--ret
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_ADJUST)
	e3:SetCondition(cm.adcon)
	e3:SetOperation(cm.retop)
	c:RegisterEffect(e3)
end
function cm.ovfilter(c)
	return c:IsFaceup() and Senya.check_set_elem(c) and c:IsXyzType(TYPE_XYZ) and c:GetOverlayCount()>=3
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) and c:CheckRemoveOverlayCard(tp,1,REASON_COST)
		and Duel.GetTurnPlayer()==tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
		and Duel.GetCurrentChain()==0
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_CARD,0,m)
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.HintSelection(g)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	if cm.adcon(e) then Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT) end
end
function cm.adcon(e)
	return e:GetHandler():GetOverlayCount()==0 and not e:GetHandler():IsDisabled() and e:GetHandler():IsAbleToExtra()
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsLocation(LOCATION_MZONE) or e:GetHandler():IsFacedown() then return end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
end