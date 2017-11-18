--Riviera 希艾拉
function c22250003.initial_effect(c)
	--SpecialSummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22250003,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_CHAINING)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCountLimit(1,222500031)
	e4:SetCondition(c22250003.spcon)
	e4:SetTarget(c22250003.sptg)
	e4:SetOperation(c22250003.spop)
	c:RegisterEffect(e4)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22250003,1))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,222500032)
	e4:SetCondition(c22250003.setcon)
	e4:SetTarget(c22250003.settg)
	e4:SetOperation(c22250003.setop)
	c:RegisterEffect(e4)
end
c22250003.named_with_Riviera=1
function c22250003.IsRiviera(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Riviera
end
function c22250003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.GetTurnPlayer()~=rp
end
function c22250003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22250003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetReset(RESET_EVENT+0xfe0000)
	e2:SetTarget(c22250003.etarget)
	e2:SetValue(c22250003.efilter)
	c:RegisterEffect(e2)
	if not c:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2,true)
	end
end
function c22250003.etarget(e,c)
	return c22250003.IsRiviera(c) and c:IsFaceup()
end
function c22250003.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function c22250003.setcfilter(c,tp,rp)
	return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and c22250003.IsRiviera(c) and c:IsReason(REASON_EFFECT)
end
function c22250003.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22250003.setcfilter,1,nil,tp,rp)
end
function c22250003.setfilter(c,ignore)
	return c22250003.IsRiviera(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(ignore)
end
function c22250003.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local sct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return c:IsAbleToGrave() and sct>0 and Duel.IsExistingMatchingCard(c22250003.setfilter,tp,LOCATION_DECK,0,1,nil,false) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function c22250003.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local lct=eg:FilterCount(c22250003.setcfilter,nil,tp,rp)
	if lct<sct then sct=lct end
	if not c:IsRelateToEffect(e) or not c:IsAbleToGrave() then return end
	if Duel.SendtoGrave(c,REASON_EFFECT)>0 and sct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=Duel.SelectMatchingCard(tp,c22250003.setfilter,tp,LOCATION_DECK,0,1,sct,nil,false)
		if sg:GetCount()>0 then
			Duel.SSet(tp,sg)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end