--DRRR!! 首领
function c80003028.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure2(c,aux.FilterBoolFunction(Card.IsCode,80003000),aux.NonTuner(c80003028.sfilter))
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,80003028) 
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c80003028.atkval)
	c:RegisterEffect(e1)  
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e2)
	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.synlimit)
	c:RegisterEffect(e3)
	--replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c80003028.indtg)
	e4:SetValue(c80003028.indval)
	c:RegisterEffect(e4)
	--to grave
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80003028,1))
	e5:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1)
	e5:SetTarget(c80003028.tdtg)
	e5:SetOperation(c80003028.tdop)
	c:RegisterEffect(e5)
	--immune
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(80003028,2))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCost(c80003028.immcost)
	e6:SetOperation(c80003028.immop)
	c:RegisterEffect(e6)
end
function c80003028.sfilter(c)
	return c:IsSetCard(0x2da) and c:IsType(TYPE_FUSION+TYPE_SYNCHRO)
end
function c80003028.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsSetCard,c:GetControler(),LOCATION_GRAVE+LOCATION_ONFIELD,0,nil,0x2da)*500
end
function c80003028.indfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsOnField() and c:IsReason(REASON_BATTLE) and c:IsSetCard(0x2da) 
end
function c80003028.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c80003028.indfilter,1,nil,tp) end
	return true
end
function c80003028.indval(e,c)
	return c80003028.indfilter(c,e:GetHandlerPlayer())
end
function c80003028.tgfilter(c)
	return c:IsSetCard(0x2da) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c80003028.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c80003028.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>0
			and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_REMOVED+LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_REMOVED+LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c80003028.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c80003028.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg1=g:Select(tp,1,1,nil)
	if Duel.SendtoGrave(tg1,REASON_EFFECT)~=0 and tg1:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
		local sg=nil
		local hg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_REMOVED,nil)
		local b1=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_REMOVED,1,nil)
		local b2=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil)
		local b3=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,nil)
		local op=0
		if not b1 and not b2 and not b3 then return end
		if b1 then
			if b2 and b3 then
				op=Duel.SelectOption(tp,aux.Stringid(80003028,3),aux.Stringid(80003028,4),aux.Stringid(80003028,5))
			elseif b2 and not b3 then
				op=Duel.SelectOption(tp,aux.Stringid(80003028,3),aux.Stringid(80003028,4))
			elseif not b2 and b3 then
				op=Duel.SelectOption(tp,aux.Stringid(80003028,3),aux.Stringid(80003028,5))
				if op==1 then op=2 end
			else
				op=0
			end
		else
			if b2 and b3 then
				op=Duel.SelectOption(tp,aux.Stringid(80003028,4),aux.Stringid(80003028,5))+1
			elseif b2 and not b3 then
				op=1
			else
				op=2
			end
		end
		if op==0 then
			sg=hg:RandomSelect(tp,1)
		elseif op==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(sg)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,1,nil)
			Duel.HintSelection(sg)
		end
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end
function c80003028.cfilter1(c)
	return c:IsSetCard(0x2da) and c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER)
end
function c80003028.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c80003028.cfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	Duel.SendtoGrave(g,REASON_COST)
end
end
function c80003028.cfilter(c)
	return c:IsType(TYPE_SYNCHRO+TYPE_XYZ+TYPE_FUSION) and c:IsAbleToRemoveAsCost()
end
function c80003028.immcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80003028.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c80003028.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c80003028.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c80003028.efilter)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c80003028.efilter(e,re)
	return re:GetOwner()~=e:GetOwner()
end