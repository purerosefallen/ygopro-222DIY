--精灵魔装-炎之魔鞭
function c5200022.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c5200022.cost)
	e1:SetTarget(c5200022.target)
	e1:SetOperation(c5200022.operation)
	c:RegisterEffect(e1)
	--Atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(800)
	c:RegisterEffect(e2)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c5200022.eqlimit)
	c:RegisterEffect(e3)
	--Damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(5200022,0))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetHintTiming(TIMING_BATTLE_START+TIMING_BATTLE_END,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e4:SetCountLimit(1)
	e4:SetTarget(c5200022.damtg)
	e4:SetOperation(c5200022.damop)
	c:RegisterEffect(e4)
	--xyz effect
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(5200022,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_SZONE)
	e5:SetHintTiming(0,TIMING_END_PHASE+0x1c0)
	e5:SetCountLimit(1,5200022)
	e5:SetCost(c5200022.xyzcost)
	e5:SetTarget(c5200022.xyztg)
	e5:SetOperation(c5200022.xyzop)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(5200022,ACTIVITY_SPSUMMON,c5200022.counterfilter)
end
function c5200022.eqlimit(e,c)
	return c:IsSetCard(0x360) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c5200022.refilter(c)
	return c:IsCode(5200008) and c:IsAbleToRemoveAsCost()
end
function c5200022.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x360) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c5200022.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5200022.refilter,tp,0x16,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c5200022.refilter,tp,0x16,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c5200022.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c5200022.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c5200022.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c5200022.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c5200022.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c5200022.cfilter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c5200022.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c5200022.cfilter(chkc) end
	local ph=Duel.GetCurrentPhase()
	if chk==0 then return Duel.IsExistingTarget(c5200022.cfilter,tp,0,LOCATION_MZONE,1,nil) and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c5200022.cfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetFirst():GetAttack())
end
function c5200022.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetAttack()>0 then
		Duel.Damage(1-tp,tc:GetAttack(),REASON_EFFECT)
	end
end
function c5200022.counterfilter(c)
	return c:IsSetCard(0x360)
end
function c5200022.xyzfilter(c)
	return c:IsSetCard(0x360) and c:IsXyzSummonable(nil)
end
function c5200022.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c5200022.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5200022.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c5200022.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c5200022.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),nil)
	end
end

