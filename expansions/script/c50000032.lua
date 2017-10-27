--Warpko 境界线
function c50000032.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk & def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x50a))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(50000032,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c50000032.spcon)
	e4:SetTarget(c50000032.sptg)
	e4:SetOperation(c50000032.spop)
	c:RegisterEffect(e4)
	--recover 2
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCondition(c50000032.recon2)
	e5:SetTarget(c50000032.retg2)
	e5:SetOperation(c50000032.reop2)
	c:RegisterEffect(e5)
end
function c50000032.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x50a)
end
function c50000032.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c50000032.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c50000032.filter(c,e,sp)
	return c:IsSetCard(0x50a) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c50000032.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50000032.filter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c50000032.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.IsExistingMatchingCard(c50000032.cfilter,tp,LOCATION_MZONE,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c50000032.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c50000032.cfilter3(c)
	return c:IsSetCard(0x50a) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c50000032.cfilter2(c,tp)
	return c:IsSetCard(0x50a) and c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:IsAbleToDeck() and c:IsPreviousLocation(LOCATION_MZONE) 
end
function c50000032.recon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c50000032.cfilter2,1,nil,tp)
end
function c50000032.retg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,eg:GetCount(),0,0)
end
function c50000032.reop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct=eg:Filter(c50000032.cfilter3,nil)
	Duel.SendtoDeck(ct,nil,2,REASON_EFFECT)
end