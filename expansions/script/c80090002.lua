--情热传说 米库里欧
function c80090002.initial_effect(c)
	c:SetUniqueOnField(1,0,80090002) 
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c80090002.spcon)
	c:RegisterEffect(e1)   
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80090002,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCondition(c80090002.descon)
	e3:SetTarget(c80090002.destg)
	e3:SetOperation(c80090002.desop)
	c:RegisterEffect(e3)
	--Activate
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,80090002)
	e5:SetCost(c80090002.drcost)
	e5:SetTarget(c80090002.target)
	e5:SetOperation(c80090002.activate)
	c:RegisterEffect(e5)
end
function c80090002.filter(c)
	return c:IsFaceup() and c:IsCode(80090000)
end
function c80090002.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c80090002.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c80090002.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c80090002.filter1(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c80090002.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80090002.filter1,tp,0,LOCATION_SZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c80090002.filter1,tp,0,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c80090002.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c80090002.filter1,tp,0,LOCATION_SZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c80090002.filter2(c,ft,e,tp)
	return c:IsCode(80090000) and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c80090002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(c80090002.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND,0,1,nil,ft,e,tp)
	end
end
function c80090002.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,0)
	local g=Duel.SelectMatchingCard(tp,c80090002.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND,0,1,1,nil,ft,e,tp)
	if g:GetCount()>0 then
		local th=g:GetFirst():IsAbleToHand()
		local sp=ft>0 and g:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false)
		local op=0
		if th and sp then op=Duel.SelectOption(tp,aux.Stringid(80090002,0),aux.Stringid(80090002,1))
		elseif th then op=0
		else op=1 end
		if op==0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		else
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c80090002.cffilter(c)
	return c:IsSetCard(0x52d4) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c80090002.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80090002.cffilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c80090002.cffilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end