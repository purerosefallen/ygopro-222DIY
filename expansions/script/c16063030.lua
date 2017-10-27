--传颂之物 aoxiu
function c16063030.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,16063030)
	e1:SetCondition(c16063030.spcon)
	e1:SetTarget(c16063030.sptg)
	e1:SetOperation(c16063030.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--atkon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,900163030)
	e3:SetCondition(c16063030.thcon)
	e3:SetTarget(c16063030.thtg)
	e3:SetOperation(c16063030.thop)
	c:RegisterEffect(e3)
end
function c16063030.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return ep==tp and ec:IsSetCard(0x5c5)
end
function c16063030.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c16063030.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
		c:CompleteProcedure()
	elseif Duel.GetMZoneCount(tp)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c16063030.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) 
end
function c16063030.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x5c5) and not c:IsHasEffect(EFFECT_DIRECT_ATTACK)
end
function c16063030.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c16063030.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16063030.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c16063030.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c16063030.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end