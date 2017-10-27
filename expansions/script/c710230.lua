--电子水蓝 圣徒
function c710230.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c710230.efilter)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,710230)
	e2:SetTarget(c710230.thtg)
	e2:SetOperation(c710230.thop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,710330)
	e3:SetTarget(c710230.sptg2)
	e3:SetOperation(c710230.spop2)
	c:RegisterEffect(e3)
	--level
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c710230.lvcost)
	e4:SetOperation(c710230.lvop)
	c:RegisterEffect(e4)
end

c710230.is_named_with_cyberaqua=1
function c710230.IsCyberAqua(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_cyberaqua
end

function c710230.efilter(e,re,tp)
	return re:GetHandlerPlayer()~=e:GetHandlerPlayer()
end

function c710230.thfilter(c)
	return c710230.IsCyberAqua(c) and c:IsAbleToHand() 
end
function c710230.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c710230.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c710230.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c710230.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c710230.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

function c710230.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c710230.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e2:SetValue(1)
		c:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(5710230,0))
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_TRIGGER)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3,true)
		Duel.SpecialSummonComplete()
	end
end

function c710230.costfilter(c,lv)
	local clv=c:GetLevel()
	return clv>0 and clv~=lv and c710230.IsCyberAqua(c) and c:IsAbleToGraveAsCost()
end
function c710230.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv=e:GetHandler():GetLevel()
	if chk==0 then return Duel.IsExistingMatchingCard(c710230.costfilter,tp,LOCATION_DECK,0,1,nil,lv) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c710230.costfilter,tp,LOCATION_DECK,0,1,1,nil,lv)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetLevel())
end
function c710230.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=e:GetLabel()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end