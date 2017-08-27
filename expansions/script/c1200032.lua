--靜儀式 靈核結晶
function c1200032.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1200032,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c1200032.target)
	e1:SetOperation(c1200032.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c1200032.eqlimit)
	c:RegisterEffect(e3)
	--adup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetCondition(c1200032.adcon)
	e4:SetValue(c1200032.atkval)
	c:RegisterEffect(e4)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c1200032.thcon)
	e4:SetTarget(c1200032.thtg)
	e4:SetOperation(c1200032.thop)
	c:RegisterEffect(e4)
	--betuner
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_ADD_TYPE)
	e4:SetValue(TYPE_TUNER)
	e4:SetCondition(c1200032.tuncon)
	c:RegisterEffect(e4)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c1200032.spcon)
	e2:SetTarget(c1200032.sptg)
	e2:SetOperation(c1200032.spop)
	c:RegisterEffect(e2)
end
function c1200032.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xfba)
end
function c1200032.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1200032.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1200032.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c1200032.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c1200032.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c1200032.eqlimit(e,c)
	return c:IsSetCard(0xfba)
end
function c1200032.adcon(e)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	if not (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return ((a==e:GetHandler():GetEquipTarget() and d) or d==e:GetHandler():GetEquipTarget())
end
function c1200032.atkval(e,c)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if ((a==e:GetHandler():GetEquipTarget() and d) or d==e:GetHandler():GetEquipTarget()) then
		local m1=a:GetLevel()
		local m2=a:GetRank()
		local n1=d:GetLevel()
		local n2=d:GetRank()
		return (m1+m2+n1+n2)*100
	end
end
function c1200032.thcon(e)
	return e:GetHandler():GetEquipTarget():IsRace(RACE_WARRIOR)
end
function c1200032.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c1200032.thop(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return false end
	Duel.SendtoHand(c,nil,REASON_EFFECT)
end
function c1200032.tuncon(e)
	return e:GetHandler():GetEquipTarget():IsRace(RACE_BEASTWARRIOR)
end
function c1200032.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetPreviousEquipTarget()
	return e:GetHandler():IsReason(REASON_LOST_TARGET) and e:GetHandler():IsLocation(LOCATION_GRAVE) and ec:IsRace(RACE_MACHINE) and not ec:IsLocation(LOCATION_ONFIELD+LOCATION_OVERLAY)
end
function c1200032.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():GetPreviousEquipTarget():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler():GetPreviousEquipTarget(),1,0,0)
end
function c1200032.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SpecialSummon(e:GetHandler():GetPreviousEquipTarget(),0,tp,tp,false,false,POS_FACEUP)
end