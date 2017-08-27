--ENS·幽音绝花、缭乱之彩
if not pcall(function() require("expansions/script/c37564765") end) then require("script/c37564765") end
function c57310004.initial_effect(c)
	Senya.ens(c,57310004)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(37564765,5))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,57310004)
	e3:SetCost(Senya.SelfReleaseCost)
	e3:SetCondition(c57310004.hdcon)
	e3:SetTarget(c57310004.hdtg)
	e3:SetOperation(c57310004.hdop)
	c:RegisterEffect(e3)
end
function c57310004.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c57310004.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(c57310004.cfilter,1,nil,1-tp)
end
function c57310004.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() 
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function c57310004.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(tp,1)
		if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)>0 then
			Senya.ensop(57310004)(e,tp,eg,ep,ev,re,r,rp)
		end
	end
end