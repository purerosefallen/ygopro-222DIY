--暗堕型佣兵亚瑟
function c17060818.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--ep effects
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060818,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c17060818.epcon)
	e1:SetTarget(c17060818.eptg)
	e1:SetOperation(c17060818.epop)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060818,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,17060818)
	e2:SetCost(c17060818.spcost)
	e2:SetTarget(c17060818.sptg)
	e2:SetOperation(c17060818.spop)
	c:RegisterEffect(e2)
	--lv
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17060818,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,170608181)
	e3:SetTarget(c17060818.target)
	e3:SetOperation(c17060818.activate)
	c:RegisterEffect(e3)
end
c17060818.is_named_with_Mercenary_Arthur=1
c17060818.is_named_with_Million_Arthur=1
c17060818.is_named_with_Dark_Degenerate=1
function c17060818.Mercenary_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Mercenary_Arthur
end
function c17060818.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060818.IsDark_Degenerate(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Dark_Degenerate
end
function c17060818.epcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c17060818.eptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c17060818.epop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c17060818.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsType,1,nil,TYPE_PENDULUM) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsType,1,1,nil,TYPE_PENDULUM)
	Duel.Release(g,REASON_COST)
end
function c17060818.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c17060818.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetMZoneCount(tp)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
		return
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c17060818.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c17060818.splimit(e,c)
	return not c:IsType(TYPE_PENDULUM) and c:IsLocation(LOCATION_EXTRA)
end
function c17060818.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:GetLevel()>0
end
function c17060818.filter2(c,tp)
	return c17060818.filter1(c) and c:IsType(TYPE_PENDULUM)
		and Duel.IsExistingMatchingCard(c17060818.filter1,tp,LOCATION_MZONE,0,1,c)
end
function c17060818.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g1=Duel.GetMatchingGroup(c17060818.filter1,tp,LOCATION_MZONE,0,nil)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c17060818.filter2(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c17060818.filter2,tp,LOCATION_MZONE,0,1,nil,tp) and g1:GetClassCount(Card.GetLevel)>1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c17060818.filter2,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c17060818.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local g=Duel.GetMatchingGroup(c17060818.filter1,tp,LOCATION_MZONE,0,tc)
		local lc=g:GetFirst()
		local lv=tc:GetLevel()
		while lc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
			e1:SetValue(lv)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			lc:RegisterEffect(e1)
			lc=g:GetNext()
		end
	end
end