--禁忌『四重存在』
function c1152303.initial_effect(c)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(c1152303.tg)
	c:RegisterEffect(e0)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)  
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCost(c1152303.cost1)
	e1:SetCondition(c1152303.con1)
	e1:SetTarget(c1152303.tg1)
	e1:SetOperation(c1152303.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)  
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c1152303.con2)
	e2:SetCost(c1152303.cost1)
	e2:SetTarget(c1152303.tg1)
	e2:SetOperation(c1152303.op2)
	c:RegisterEffect(e2)
--  
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c1152303.con3)
	e3:SetTarget(c1152303.tg3)
	e3:SetOperation(c1152303.op3)
	c:RegisterEffect(e3)
--  
end
--
function c1152303.IsFulan(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Fulan
end
c1152303.named_with_Fulsp=1
function c1152303.IsFulsp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Fulsp
end
--
function c1152303.tfilter(c,e,tp)
	return c1152303.IsFulan(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c1152303.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_CHAINING,true)
	if res and c1152303.con1(e,tp,teg,tep,tev,tre,tr,trp)
		and Duel.IsExistingMatchingCard(c1152303.tfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,94) and Duel.GetFlagEffect(tp,1152206)<3 then
		Duel.RegisterFlagEffect(tp,1152303,0,0,0)
		e:SetOperation(c1152303.op1)
	else
		e:SetOperation(nil)
	end
	local res2,teg2,tep2,tev2,tre2,tr2,trp2=Duel.CheckEvent(EVENT_BE_BATTLE_TARGET,true)
	if res2 and c1152303.con2(e,tp,teg,tep,tev,tre,tr,trp) and Duel.IsExistingMatchingCard(c1152303.tfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,94) and Duel.GetFlagEffect(tp,1152206)<3 then
		Duel.RegisterFlagEffect(tp,1152303,0,0,0)
		e:SetOperation(c1152303.op2)
	else
		e:SetOperation(nil)
	end
end
--
function c1152303.cfilter1(c,tp)
	return c:IsFaceup() and c1152303.IsFulan(c) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c1152303.con1(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c1152303.cfilter1,1,nil,tp) 
end
--
function c1152303.con2(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return at:IsControler(tp) and at:IsFaceup() and c1152303.IsFulan(at) and at:IsType(TYPE_MONSTER)
end
--
function c1152303.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():GetOriginalCode()==1152303 then
		Duel.RegisterFlagEffect(tp,1152303,0,0,0)
	end
end
--
function c1152303.tfilter1(c,e,tp)
	return c1152303.IsFulan(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1152303.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1152303.tfilter1,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFlagEffect(tp,1152206)<3 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
--
function c1152303.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c1152303.tfilter1,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then   
			local tf=re:GetTarget()
			local res,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(re:GetCode(),true)
			if tf(re,rp,ceg,cep,cev,cre,cr,crp,0,g:GetFirst()) and Duel.SelectYesNo(tp,aux.Stringid(1152303,0)) then
				Duel.BreakEffect()
				Duel.ChangeTargetCard(ev,Group.FromCards(g:GetFirst()))
			end
		end
	end
end
--
function c1152303.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c1152303.tfilter1,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then   
			if not Duel.GetAttacker():IsImmuneToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(1152303,1)) then
				Duel.BreakEffect()
				Duel.ChangeAttackTarget(g:GetFirst())
			end
		end
	end
end
--
function c1152303.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
--
function c1152303.tfilter3(c)
	return c1152303.IsFulan(c) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c1152303.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c1152303.tfilter3(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c1152303.tfilter3,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g=Duel.SelectTarget(tp,c1152303.tfilter3,tp,LOCATION_ONFIELD,0,1,1,nil)
end
--
function c1152303.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local e3_1=Effect.CreateEffect(tc)
		e3_1:SetDescription(aux.Stringid(1152303,2))
		e3_1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e3_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3_1:SetCode(EVENT_CHAINING)
		e3_1:SetRange(LOCATION_MZONE)
		e3_1:SetReset(RESET_EVENT+0x1fe0000)
		e3_1:SetTarget(c1152303.tg3_1)
		e3_1:SetOperation(c1152303.op3_1)
		tc:RegisterEffect(e3_1)
	end
end
function c1152303.tg3_1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local i=0
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if tg and tg:GetCount()>0 then
		local tc=tg:GetFirst()
		while tc do
			if tc==e:GetHandler() then
				i=1
			end
			tc=tg:GetNext()
		end
	end  
	if chk==0 then return i==0 end
end
function c1152303.op3_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local r1,r2=Duel.TossCoin(tp,2)
	if r1+r2~=0 then
		local tc=re:GetHandler()
		local num=tc:GetCode()
		local e3_1_1=Effect.CreateEffect(c)
		e3_1_1:SetType(EFFECT_TYPE_SINGLE)
		e3_1_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3_1_1:SetRange(LOCATION_MZONE)
		e3_1_1:SetCode(EFFECT_IMMUNE_EFFECT)
		e3_1_1:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
		e3_1_1:SetLabel(num)
		e3_1_1:SetValue(c1152303.efilter3_1_1)
		c:RegisterEffect(e3_1_1)
	end
end
function c1152303.efilter3_1_1(e,re)
	local num=e:GetLabel()
	return re:GetHandler():GetCode()==num
end
--