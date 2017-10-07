--Solid 零一四三
function c22241201.initial_effect(c)
	c:SetUniqueOnField(1,0,22241201)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22241201,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,22241201)
	e2:SetCondition(c22241201.drcon)
	e2:SetTarget(c22241201.drtg)
	e2:SetOperation(c22241201.drop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22241201,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,22241201)
	e1:SetTarget(c22241201.target)
	e1:SetOperation(c22241201.activate)
	c:RegisterEffect(e1)
end
c22241201.named_with_Solid=1
function c22241201.IsSolid(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Solid
end
function c22241201.ccfilter(c,tp)
	return bit.band(c:GetReason(),REASON_RELEASE)~=0 and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp and bit.band(c:GetOriginalType(),0x81)==0x81
end
function c22241201.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22241201.ccfilter,1,nil,tp)
end
function c22241201.spfilter(c,e,tp,olv)
	return bit.band(c:GetType(),0x81)==0x81 and c22241201.IsSolid(c) and c:IsLevelBelow(olv) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c22241201.trfilter(c,e,tp)
	local olv=c:GetOriginalLevel()
	return bit.band(c:GetType(),0x81)==0x81 and c22241201.IsSolid(c) and c:IsReleasableByEffect() and Duel.IsExistingMatchingCard(c22241201.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,olv)
end
function c22241201.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c22241201.trfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
end
function c22241201.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local rg=Duel.SelectMatchingCard(tp,c22241201.trfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local rc=rg:GetFirst()
	if rc then
		Duel.SendtoGrave(rc,REASON_EFFECT+REASON_RELEASE)
		local olv=rc:GetOriginalLevel()
		local sg=Duel.SelectMatchingCard(tp,c22241201.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,olv)
		local sc=sg:GetFirst()
		if sc then Duel.SpecialSummon(sc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP) end
	end
end
function c22241201.tgfilter(c)
	return bit.band(c:GetReason(),REASON_RELEASE)~=0 and c:IsAbleToHand()
end
function c22241201.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c22241201.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22241201.tgfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c22241201.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c22241201.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

