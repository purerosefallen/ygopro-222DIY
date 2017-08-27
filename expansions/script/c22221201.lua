--白泽球的诞生
function c22221201.initial_effect(c)
	c:SetUniqueOnField(1,0,22221201)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22221201,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,22221201)
	e2:SetCost(c22221201.spcost)
	e2:SetTarget(c22221201.sptg)
	e2:SetOperation(c22221201.spop)
	c:RegisterEffect(e2)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22221201,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCost(c22221201.cost)
	e2:SetTarget(c22221201.target)
	e2:SetOperation(c22221201.activate)
	c:RegisterEffect(e2)

end
c22221201.named_with_Shirasawa_Tama=1
function c22221201.IsShirasawaTama(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Shirasawa_Tama
end
function c22221201.rfilter(c)
	return c22221201.IsShirasawaTama(c) and c:IsType(TYPE_MONSTER) and ((c:IsFaceup() and c:IsLocation(LOCATION_MZONE)) or c:IsLocation(LOCATION_HAND)) and c:IsAbleToRemoveAsCost()
end 
function c22221201.spfilter(c,e,tp)
	return c22221201.IsShirasawaTama(c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
end
function c22221201.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22221201.rfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c22221201.rfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
	tc:CompleteProcedure()
end
function c22221201.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22221201.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c22221201.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22221201.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP) then
			Duel.BreakEffect()
			Duel.Recover(tp,600,REASON_EFFECT)
		end
	end
end
function c22221201.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,1,REASON_COST)
end
function c22221201.filter(c)
	return c22221201.IsShirasawaTama(c) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToRemove()
end
function c22221201.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22221201.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1200)
end
function c22221201.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c22221201.filter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.Recover(tp,1200,REASON_EFFECT)
	end
end
