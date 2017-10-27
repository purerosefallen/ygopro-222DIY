--逆行技瑟
function c17060852.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pendulum set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060852,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c17060852.pencon)
	e1:SetTarget(c17060852.pentg)
	e1:SetOperation(c17060852.penop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060852,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,17060852)
	e2:SetTarget(c17060852.thtg)
	e2:SetOperation(c17060852.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(17060852,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,170608521)
	e4:SetCondition(c17060852.spcon)
	e4:SetTarget(c17060852.sptg)
	e4:SetOperation(c17060852.spop)
	c:RegisterEffect(e4)
end
c17060852.is_named_with_Backwards=1
c17060852.is_named_with_Skill_Field=1
c17060852.is_named_with_Million_Arthur=1
function c17060852.Backwards(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Backwards
end
function c17060852.IsSkill_Field(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Skill_Field
end
function c17060852.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060852.pencon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local sc=Duel.GetFirstMatchingCard(nil,tp,LOCATION_PZONE,0,e:GetHandler())
	return sc and (c17060852.IsMillion_Arthur(sc) or sc.named_with_Backwards)
end
function c17060852.pcfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c17060852.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local seq=e:GetHandler():GetSequence()
	local sc=Duel.GetFirstMatchingCard(nil,tp,LOCATION_PZONE,0,e:GetHandler())
	if chk==0 then return Duel.IsExistingMatchingCard(c17060852.pcfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetTargetCard(sc)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sc,1,0,0)
end
function c17060852.penop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c17060852.pcfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
function c17060852.thfilter(c)
	return c:GetLevel()==1 and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c17060852.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17060852.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c17060852.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c17060852.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c17060852.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c17060852.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c17060852.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end