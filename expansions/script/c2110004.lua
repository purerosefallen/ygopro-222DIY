--龙魂苏醒
function c2110004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,2110004)
	e1:SetTarget(c2110004.target)
	e1:SetOperation(c2110004.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,2111004)
	e2:SetCost(c2110004.thcost)
	e2:SetTarget(c2110004.thtg)
	e2:SetOperation(c2110004.thop)
	c:RegisterEffect(e2)
end
function c2110004.tfilter(c,e,tp)
	return c:GetRank()==6 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c2110004.chkfilter(c)
	return c:IsFaceup() and c:IsCode(2110000) and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c2110004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c2110004.chkfilter(chkc,e:GetLabel()) end
	if chk==0 then return Duel.GetMZoneCount(tp)>-1
		and Duel.IsExistingTarget(c2110004.chkfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c2110004.chkfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c2110004.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<0 then return end
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c2110004.tfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
function c2110004.relfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsReleasable()
end
function c2110004.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c2110004.relfilter,1,nil) end
	local g=Duel.SelectReleaseGroupEx(tp,c2110004.relfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c2110004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c2110004.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end