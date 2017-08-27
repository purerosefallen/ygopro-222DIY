--遗失的眼镜
function c13245302.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13245302,0))
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c13245302.condition)
	e1:SetOperation(c13245302.activate)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c13245302.target)
	e1:SetOperation(c13245302.activate1)
	c:RegisterEffect(e1)	
end
function c13245302.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT)
end
function c13245302.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	local g=Duel.GetMatchingGroup(Card.IsDiscardable,p,LOCATION_HAND,0,nil)
	if g:GetCount()>=1 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DISCARD)
		local sg=g:RandomSelect(p,1)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	end
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_PUBLIC)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetCondition(c13245302.con1)
	e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_PUBLIC)
	e4:SetTargetRange(0,LOCATION_HAND)
	e4:SetCondition(c13245302.con2)
	e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
	Duel.RegisterEffect(e4,tp)
end
function c13245302.con1(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c13245302.con2(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function c13245302.tgfilter(c)
	return c:IsSetCard(0x209) and c:IsAbleToGrave()
end
function c13245302.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13245302.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c13245302.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c13245302.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
