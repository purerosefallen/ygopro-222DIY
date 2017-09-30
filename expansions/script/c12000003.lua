--奇迹糕点 糕点爆发
function c12000003.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c12000003.cost)
	e1:SetCountLimit(1,12000003+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c12000003.target)
	e1:SetOperation(c12000003.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c12000003.spcon)
	e2:SetTarget(c12000003.sptg)
	e2:SetOperation(c12000003.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c12000003.descost)
	e3:SetTarget(c12000003.destg)
	e3:SetOperation(c12000003.desop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(c12000003.thcost)
	e4:SetTarget(c12000003.thtg)
	e4:SetOperation(c12000003.thop)
	c:RegisterEffect(e4)
	
end
function c12000003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c12000003.filter(c)
	return c:IsSetCard(0xfbe) and c:IsAbleToHand()
end
function c12000003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12000003.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12000003.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12000003.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c12000003.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xfbe) and c:IsType(TYPE_MONSTER)
end
function c12000003.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c12000003.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c12000003.cfilter2(c)
	return c:IsType(TYPE_TOKEN)
end
function c12000003.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c12000003.cfilter2,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c12000003.cfilter2,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c12000003.cfilter(c,tp)
	return c:IsType(TYPE_TOKEN)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c12000003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12000003.cfilter,1,nil,tp)
end
function c12000003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,12000012,0xfbe,0x4011,500,500,2,RACE_BEAST,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c12000003.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,12000012,0xfbe,0x4011,500,500,2,RACE_BEAST,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,12000012)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
				  e1:SetType(EFFECT_TYPE_SINGLE)
				  e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
				  e1:SetValue(1)
				  e1:SetReset(RESET_EVENT+0x1fe0000)
				  token:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
end
function c12000003.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c12000003.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c12000003.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c12000003.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c12000003.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and e:GetHandler():IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c12000003.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c12000003.thfilter(c,att,race)
	return c:IsAttribute(att) and c:IsRace(race) and c:IsAbleToHand() and c:IsLevelAbove(5)
end
function c12000003.cfilter3(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_TOKEN) and Duel.IsExistingMatchingCard(c12000003.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetAttribute(),c:GetRace())
end
function c12000003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c12000003.cfilter3,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c12000003.cfilter3,1,1,nil)
	Duel.Release(g,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	e:SetLabelObject(g:GetFirst())
end
function c12000003.thop(e,tp,eg,ep,ev,re,r,rp)
	local att=e:GetLabelObject():GetAttribute()
	local race=e:GetLabelObject():GetRace()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12000003.thfilter,tp,LOCATION_DECK,0,1,1,nil,att,race)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
