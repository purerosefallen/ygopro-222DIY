--閉ざされた魔女の偽街
function c114001229.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c114001229.condition)
	e1:SetTarget(c114001229.target)
	e1:SetOperation(c114001229.activate)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xcabb))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--remove
	--local e3=Effect.CreateEffect(c)
	--e3:SetType(EFFECT_TYPE_FIELD)
	--e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	--e3:SetRange(LOCATION_SZONE)
	--e3:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	--e3:SetTargetRange(0xff,0xff)
	--e3:SetValue(LOCATION_REMOVED)
	--c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c114001229.spcon)
	e4:SetTarget(c114001229.sptg)
	e4:SetOperation(c114001229.spop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e6)
end
function c114001229.confilter(c)
	return c:IsFaceup()
		and ( c:IsSetCard(0x223) or c:IsSetCard(0x224) or c:IsSetCard(0xcabb) 
		or c:IsCode(36405256) or c:IsCode(54360049) or c:IsCode(37160778) or c:IsCode(27491571) or c:IsCode(80741828) or c:IsCode(90330453) --0x223
		or c:IsCode(32751480) or c:IsCode(78010363) or c:IsCode(39432962) or c:IsCode(67511500) or c:IsCode(62379337) or c:IsCode(23087070) or c:IsCode(17720747) or c:IsCode(98358303) or c:IsCode(91584698) ) --0x224
end
function c114001229.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c114001229.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function c114001229.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcabb) and c:IsAbleToRemove()
end
function c114001229.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114001229.rmfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c114001229.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c114001229.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tg=g:GetFirst()
	if tg==nil then return end
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end


function c114001229.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD) and bit.band(r,0x40)==0x40 
end
function c114001229.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c114001229.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelAbove(5)
		and ( c:IsSetCard(0x223) or c:IsSetCard(0x224)
		or c:IsCode(36405256) or c:IsCode(54360049) or c:IsCode(37160778) or c:IsCode(27491571) or c:IsCode(80741828) or c:IsCode(90330453) --0x223
		or c:IsCode(32751480) or c:IsCode(78010363) or c:IsCode(39432962) or c:IsCode(67511500) or c:IsCode(62379337) or c:IsCode(23087070) or c:IsCode(17720747) or c:IsCode(98358303) or c:IsCode(91584698) ) --0x224
end
function c114001229.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local sg=Duel.GetMatchingGroup(c114001229.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c114001229.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		local shuf=false
		if tc:IsLocation(LOCATION_HAND) then shuf=true end
		Duel.SpecialSummon(g,303,tp,tp,false,false,POS_FACEUP)
		if shuf then Duel.ShuffleDeck(tp) end
	--else
		--local cg=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
		--Duel.ConfirmCards(1-tp,cg)
		--Duel.ShuffleDeck(tp)
		--local cg2=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		--Duel.ConfirmCards(1-tp,cg2)
		--Duel.ShuffleHand(tp)
	end
end