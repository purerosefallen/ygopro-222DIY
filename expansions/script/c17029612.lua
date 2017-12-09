--Psychether Dream Overseer, Helmretta
function c17029612.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),4,3)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--confirm
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(17029612,1))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1,17029612)
	e5:SetCondition(c17029612.cfcon)
	e5:SetCost(c17029612.cfcost)
	e5:SetTarget(c17029612.cftg)
	e5:SetOperation(c17029612.cfop)
	c:RegisterEffect(e5)
	--Banish
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(17029612,0))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetCountLimit(1,17029622)
	e6:SetCondition(c17029612.rmcon)
	e6:SetTarget(c17029612.rmtg)
	e6:SetOperation(c17029612.rmop)
	c:RegisterEffect(e6)
end
function c17029612.cfcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_SPELL)
end
function c17029612.cfcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c17029612.revfilter(c)
	return not c:IsPublic()
end
function c17029612.cftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil)
		or Duel.IsExistingMatchingCard(c17029612.revfilter,tp,0,LOCATION_HAND,1,nil)) end
	Duel.SetChainLimit(c17029612.chlimit)
end
function c17029612.chlimit(e,ep,tp)
	return tp==ep
end
function c17029612.handfilter(c)
	return not c:IsPublic()
end
function c17029612.cfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	Duel.ConfirmCards(tp,g)
	local g2=Duel.GetMatchingGroup(c17029612.handfilter,tp,0,LOCATION_HAND,nil)
	if g2:GetCount()>0 then
		local tc=g2:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc=g2:GetNext()
		end
	end
end
function c17029612.afilter(c,tp)
	return c:IsType(TYPE_SPELL) and c:GetPreviousControler()==tp 
		and c:IsSetCard(0x720)
end
function c17029612.bfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x720)
end
function c17029612.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c17029612.bfilter,c:GetControler(),LOCATION_GRAVE,0,nil)
	local ct=g1:GetClassCount(Card.GetCode)
	return eg:IsExists(c17029611.afilter,1,nil,tp) and ct>2
end
function c17029612.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c17029612.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
