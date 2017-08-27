--自由斗士·持剑的涅法格
function c10131003.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,true)
	--pe
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10131003,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,10131003)
	e1:SetCost(c10131003.pccost)
	e1:SetTarget(c10131003.pctg)
	e1:SetOperation(c10131003.pcop)
	c:RegisterEffect(e1)
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10131003,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c10131003.sptg)
	e2:SetOperation(c10131003.spop)
	c:RegisterEffect(e2)
end
function c10131003.spfilter(c,e,sp)
	return c:IsSetCard(0x5338) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,sp,false,false) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsType(TYPE_PENDULUM)
end
function c10131003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10131003.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c10131003.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10131003.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
	   Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function c10131003.pccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c10131003.pctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
	if chk==0 then return tc and tc:IsSetCard(0x5338) and tc:IsCanBeEffectTarget(e) and tc:GetRightScale()~=9 and tc:GetLeftScale()~=9 end
	Duel.SetTargetCard(tc)
end
function c10131003.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LSCALE)
		e1:SetValue(9)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RSCALE)
		tc:RegisterEffect(e2)
	end
end
