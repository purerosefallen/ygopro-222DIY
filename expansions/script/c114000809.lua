--★因果を束ねられた魔法少女 鹿目まどか
function c114000809.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c114000809.spcon)
	e1:SetTarget(c114000809.sptg)
	e1:SetOperation(c114000809.spop)
	c:RegisterEffect(e1)
	--return to hand + atkchange
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_LVCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c114000809.atkcon)
	e2:SetOperation(c114000809.atkop)
	c:RegisterEffect(e2)
end
--special summon
function c114000809.spfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x221)
end
function c114000809.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and not Duel.IsExistingMatchingCard(c114000809.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c114000809.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c114000809.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--return to hand + atkchange
function c114000809.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re 
	and ( rc:IsSetCard(0xcabb) or rc:IsSetCard(0x223) or rc:IsSetCard(0x224) or rc:IsSetCard(0x5047)
	or rc:IsCode(36405256) or rc:IsCode(54360049) or rc:IsCode(37160778) or rc:IsCode(27491571) or rc:IsCode(80741828) or rc:IsCode(90330453) --0x223
	or rc:IsCode(32751480) or rc:IsCode(78010363) or rc:IsCode(39432962) or rc:IsCode(67511500) or rc:IsCode(62379337) or rc:IsCode(23087070) or rc:IsCode(17720747) or rc:IsCode(98358303) or rc:IsCode(91584698) ) --0x224
	and e:GetHandler():GetSummonType()~=SUMMON_TYPE_PENDULUM
end
function c114000809.atkfilter(c)
	return c:IsFaceup() and c:IsCode(114000809)
end
function c114000809.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY) 
	--and not c:IsStatus(STATUS_BATTLE_DESTROYED) --only for not choosing monsters confirmed to be destroyed by battle
end
function c114000809.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--return to hand
	local sg=Duel.GetMatchingGroup(c114000809.tgfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(114000809,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tg=sg:Select(tp,1,1,nil)
		Duel.HintSelection(tg)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
	--self status changing
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local ct=Duel.GetMatchingGroupCount(c114000809.atkfilter,tp,LOCATION_REMOVED,0,nil)
		if ct>0 then
			Duel.BreakEffect()
			--level up
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetValue(ct*2)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			c:RegisterEffect(e1)
			--atkup
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(ct*800)
			e2:SetReset(RESET_EVENT+0x1ff0000)
			c:RegisterEffect(e2)
		end
	end
end