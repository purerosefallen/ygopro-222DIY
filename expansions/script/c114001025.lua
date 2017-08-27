--★喰い散らかす氷海鴨（ガッツァイダー）
function c114001025.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,4)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,114001025+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c114001025.spcon)
	e1:SetCost(c114001025.spcost)
	e1:SetTarget(c114001025.sptg)
	e1:SetOperation(c114001025.spop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCondition(c114001025.descon)
	e2:SetTarget(c114001025.destg)
	e2:SetOperation(c114001025.desop)
	c:RegisterEffect(e2)
end
function c114001025.confilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE) and c:GetReasonPlayer()~=tp
end
function c114001025.confilter2(c)
	return ( c:IsType(TYPE_XYZ) or c:IsLevelAbove(5) ) and c:IsFaceup()
end
function c114001025.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c114001025.confilter,1,nil,tp) and Duel.IsExistingMatchingCard(c114001025.confilter2,tp,0,LOCATION_MZONE,1,nil)
end
function c114001025.spcfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c114001025.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114001025.spcfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c114001025.spcfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c114001025.spfilter(c)
	return c:IsSetCard(0x221) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4)
end
function c114001025.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c114001025.spfilter,tp,LOCATION_DECK,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) --end
		and ct>=4 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c114001025.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		c:CompleteProcedure()
		local g=Duel.GetMatchingGroup(c114001025.spfilter,tp,LOCATION_DECK,0,nil)
		if g:GetClassCount(Card.GetCode)<4 then return end
		local rg=Group.CreateGroup()
		Duel.BreakEffect()
		for i=1,4 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			if tc then
				rg:AddCard(tc)
				g:Remove(Card.IsCode,nil,tc:GetCode())
			end
		end
		Duel.Overlay(c,rg)
	end
end

function c114001025.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c114001025.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c114001025.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end