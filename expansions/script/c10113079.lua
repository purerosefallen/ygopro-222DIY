--美食家幽灵
function c10113079.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2830693,0))
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10113079)
	e1:SetTarget(c10113079.eqtg)
	e1:SetOperation(c10113079.eqop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10113079,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c10113079.spcon)
	e2:SetCost(c10113079.spcost)
	e2:SetTarget(c10113079.sptg)
	e2:SetOperation(c10113079.spop)
	c:RegisterEffect(e2)	
end
function c10113079.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local at=Duel.GetAttacker()
	if chkc then return chkc==at end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and at:IsControler(1-tp) and at:IsRelateToBattle() and at:IsCanBeEffectTarget(e) and at:IsAttackPos() end
	Duel.SetTargetCard(at)
end
function c10113079.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
	else
		if Duel.Equip(tp,c,tc,true) then
		   local e1=Effect.CreateEffect(tc)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_EQUIP_LIMIT)
		   e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		   e1:SetReset(RESET_EVENT+0x1fe0000)
		   e1:SetValue(c10113079.eqlimit)
		   c:RegisterEffect(e1)
		   if tc:IsAttackPos() then
			  Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		   end
		end
	end
end
function c10113079.eqlimit(e,c)
	return e:GetOwner()==c
end
function c10113079.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()
end
function c10113079.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c10113079.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetEquipTarget():IsCanTurnSet() end
	Duel.SetTargetCard(c:GetEquipTarget())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c:GetEquipTarget(),1,0,0)
end
function c10113079.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
		return
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsCanTurnSet() then
	   Duel.BreakEffect()
	   Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end