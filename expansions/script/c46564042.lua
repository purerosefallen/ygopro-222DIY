--冬 春 倒 转 哀 歌
function c46564042.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(46564042,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,46564042+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c46564042.target)
	e1:SetOperation(c46564042.activate)
	c:RegisterEffect(e1) 
	--colour summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(46564042,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1)
	e2:SetCondition(c46564042.effcon)
	e2:SetTarget(c46564042.thtg)
	e2:SetOperation(c46564042.thop)
	e2:SetLabel(TYPE_RITUAL)
	c:RegisterEffect(e2)
	local e5=e2:Clone()
	e5:SetDescription(aux.Stringid(46564042,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetTarget(c46564042.sptg)
	e5:SetOperation(c46564042.spop)
	e5:SetLabel(TYPE_XYZ)
	c:RegisterEffect(e5)	
	--check material
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCode(EFFECT_MATERIAL_CHECK)
	e6:SetValue(c46564042.valcheck)
	c:RegisterEffect(e6)
end
function c46564042.filter(c)
	return c:IsRace(RACE_AQUA) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsLevelAbove(4) and c:IsLevelBelow(4) and c:IsAbleToGrave()
end
function c46564042.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c46564042.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c46564042.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c46564042.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c46564042.mtfilter(c)
	return c:IsRace(RACE_AQUA) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c46564042.valcheck(e,c)
	if c:GetMaterial():IsExists(c46564042.mtfilter,1,nil) then
		c:RegisterFlagEffect(46564042,RESET_EVENT+0x4fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c46564042.effcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==1 and eg:GetFirst():IsType(e:GetLabel()) and eg:GetFirst():GetFlagEffect(46564042)~=0
end
function c46564042.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
end
function c46564042.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function c46564042.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c46564042.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c46564042.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c46564042.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c46564042.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end