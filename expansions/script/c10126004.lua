--反骨的狂士 勇
function c10126004.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,10126004)
	e1:SetCondition(c10126004.spcon)
	e1:SetOperation(c10126004.spop)
	c:RegisterEffect(e1)   
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10126004,0))
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetCountLimit(1,10126104)
	e2:SetCost(c10126004.cost)
	e2:SetCondition(c10126004.condition)
	e2:SetTarget(c10126004.target)
	e2:SetOperation(c10126004.operation)
	--c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10126004,1))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(c10126004.eqcon)
	e3:SetTarget(c10126004.eqtg)
	e3:SetOperation(c10126004.eqop)
	c:RegisterEffect(e3)
	--special summon equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10126004,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetCountLimit(1)
	e4:SetTarget(c10126004.sptg2)
	e4:SetOperation(c10126004.spop2)
	c:RegisterEffect(e4)
end
function c10126004.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if not c:IsRelateToBattle() or c:IsFacedown() then return false end
	e:SetLabelObject(tc)
	return tc:IsLocation(LOCATION_GRAVE) and tc:IsType(TYPE_MONSTER) and tc:IsReason(REASON_BATTLE)
end
function c10126004.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=e:GetLabelObject()
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tc,1,0,0)
end
function c10126004.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
		if not Duel.Equip(1-tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c10126004.eqlimit)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(100)
		tc:RegisterEffect(e2)
	end
end
function c10126004.spfilter(c,e,tp)
	local ec=c:GetEquipTarget()  
	return ec and ec:IsControler(tp)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10126004.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10126004.spfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_SZONE)
end
function c10126004.spop2(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10126004.spfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10126004.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c10126004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c10126004.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.NegateSummon(eg)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	if Duel.Destroy(eg,REASON_EFFECT)==0 or ft<=0 then return end
	  local og=Duel.GetOperatedGroup():Filter(Card.IsType,nil,TYPE_MONSTER)
	  if ft>og:GetCount() then ft=og:GetCount() end
	  Duel.BreakEffect()
	  Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_EQUIP)
	  local eqg=og:Select(1-tp,ft,ft,nil)
	  local ec=eqg:GetFirst()
	  while ec do
		if Duel.Equip(1-tp,ec,c,false,true) then 
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c10126004.eqlimit)
			ec:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetValue(100)
			ec:RegisterEffect(e2)
		end
	 ec=eqg:GetNext()
	 end
	 Duel.EquipComplete()
end
function c10126004.eqlimit(e,c)
	return e:GetOwner()==c
end
function c10126004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10126003.spfilter1,tp,LOCATION_SZONE,LOCATION_SZONE,2,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c10126003.spfilter1,tp,LOCATION_SZONE,LOCATION_SZONE,2,2,nil,tp)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c10126004.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10126004.spfilter1,tp,LOCATION_SZONE,LOCATION_SZONE,3,nil,tp)
end
function c10126004.spfilter1(c,tp)
	local ec=c:GetEquipTarget()
	return ec and ec:IsControler(tp) 
end
function c10126004.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c10126004.spfilter1,tp,LOCATION_SZONE,LOCATION_SZONE,3,3,nil,tp)
	Duel.SendtoGrave(sg,REASON_COST)
end
