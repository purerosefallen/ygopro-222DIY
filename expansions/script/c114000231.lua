--★(ドリームスター)魔女狩り殺しの魔法少女 イスカ
function c114000231.initial_effect(c)
	--cannot be battle target
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e1:SetTarget(c114000231.bttg)
    e1:SetValue(1)
    c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetTarget(c114000231.target)
	e2:SetOperation(c114000231.operation)
	c:RegisterEffect(e2)
end
--battle target limit
function c114000231.bttg(e,c)
	return c~=e:GetHandler() and c:IsFaceup() 
	and ( c:IsSetCard(0xcabb) 
		or c:IsSetCard(0x223) or c:IsSetCard(0x224) 
		or c:IsCode(36405256) or c:IsCode(54360049) or c:IsCode(37160778) or c:IsCode(27491571) or c:IsCode(80741828) or c:IsCode(90330453) --0x223
		or c:IsCode(78010363) or c:IsCode(39432962) or c:IsCode(67511500) or c:IsCode(62379337) or c:IsCode(23087070) or c:IsCode(98358303) or c:IsCode(17720747) or c:IsCode(32751480) or c:IsCode(91584698) ) --0x224
end
--atk up function
function c114000231.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) 
	and ( c:IsSetCard(0xcabb) 
		or c:IsSetCard(0x223) or c:IsSetCard(0x224) 
		or c:IsCode(36405256) or c:IsCode(54360049) or c:IsCode(37160778) or c:IsCode(27491571) or c:IsCode(80741828) or c:IsCode(90330453) --0x223
		or c:IsCode(78010363) or c:IsCode(39432962) or c:IsCode(67511500) or c:IsCode(62379337) or c:IsCode(23087070) or c:IsCode(98358303) or c:IsCode(17720747) or c:IsCode(32751480) or c:IsCode(91584698) ) --0x224
end
function c114000231.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c114000231.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c114000231.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACK)
	Duel.SelectTarget(tp,c114000231.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
end
function c114000231.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFacedown() or not c:IsRelateToEffect(e) 
		or not tc:IsPosition(POS_FACEUP_ATTACK) or not tc:IsRelateToEffect(e) then return end
	Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
	local atkval=tc:GetAttack()/2
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atkval)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end