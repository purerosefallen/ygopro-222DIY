--感谢贼
function c17060829.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--scale change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060829,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c17060829.sccon)
	e1:SetTarget(c17060829.sctg)
	e1:SetOperation(c17060829.scop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060829,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,17060829)
	e2:SetTarget(c17060829.sptg)
	e2:SetOperation(c17060829.spop)
	c:RegisterEffect(e2)
end
c17060829.is_named_with_Million_Arthur=1
function c17060829.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060829.cfilter(c)
	return c17060829.IsMillion_Arthur(c)
end
function c17060829.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c17060826.cfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c17060829.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLeftScale()~=7 end
end
function c17060829.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:GetLeftScale()==7 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LSCALE)
	e1:SetValue(9)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e2)
end

function c17060829.filter(c,e,tp)
	return c:IsType(TYPE_PENDULUM)
end
function c17060829.spfilter(c,e,tp)
	return c17060829.IsMillion_Arthur(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c17060829.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and c17060829.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c17060829.filter,tp,LOCATION_PZONE,0,1,nil,e,tp)
	and Duel.GetMZoneCount(tp)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c17060829.filter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c17060829.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		if Duel.GetMZoneCount(tp)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c17060829.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end