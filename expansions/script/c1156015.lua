--雾雨的魔法使
function c1156015.initial_effect(c)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c1156015.lkcon)
	e0:SetOperation(c1156015.lkop)
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
--  
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1156015,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c1156015.con2)
	e2:SetTarget(c1156015.tg2)
	e2:SetOperation(c1156015.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c1156015.value3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c1156015.tg4)
	c:RegisterEffect(e4)
--
end
--
function c1156015.lkfilter(c,lc,tp)
	local flag=c:IsFaceup() and c:IsCanBeLinkMaterial(lc)
	if c:IsType(TYPE_MONSTER) then
		return flag and c:IsRace(RACE_SPELLCASTER)
	else
		return flag and c:IsType(TYPE_SPELL)
	end
end
function c1156015.lvfilter(c)
	if c:IsType(TYPE_LINK) and c:GetLink()>1 then
		return 1+0x10000*c:GetLink()
	else 
		return 1 
	end
end
--
function c1156015.lcheck(tp,sg,lc,minc,ct)
	return ct>=minc and sg:CheckWithSumEqual(c1156015.lvfilter,lc:GetLink(),ct,ct) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
end
function c1156015.lkchenk(c,tp,sg,mg,lc,ct,minc,maxc)
	sg:AddCard(c)
	ct=ct+1
	local res=c1156015.lcheck(tp,sg,lc,minc,ct) or (ct<maxc and mg:IsExists(c1156015.lkchenk,1,sg,tp,sg,mg,lc,ct,minc,maxc))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
--
function c1156015.lkcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c1156015.lkfilter,tp,LOCATION_ONFIELD,0,nil,c,tp)
	local sg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
		local pc=pe:GetHandler()
		if not mg:IsContains(pc) then return false end
		sg:AddCard(pc)
	end
	local ct=sg:GetCount()
	local minc=3
	local maxc=3
	if ct>maxc then return false end
	return c1156015.lcheck(tp,sg,c,minc,ct) or mg:IsExists(c1156015.lkchenk,1,nil,tp,sg,mg,c,ct,minc,maxc)
end
--
function c1156015.lkop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c1156015.lkfilter,tp,LOCATION_ONFIELD,0,nil,c,tp)
	local sg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
		sg:AddCard(pe:GetHandler())
	end
	local ct=sg:GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	sg:Select(tp,ct,ct,nil)
	local minc=3
	local maxc=3
	for i=ct,maxc-1 do
		local cg=mg:Filter(c1156015.lkchenk,sg,tp,sg,mg,c,i,minc,maxc)
		if cg:GetCount()==0 then break end
		local minct=1
		if c1156015.lcheck(tp,sg,c,minc,i) then
			if not Duel.SelectYesNo(tp,210) then break end
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		local g=cg:Select(tp,minct,1,nil)
		if g:GetCount()==0 then break end
		sg:Merge(g)
	end
	c:SetMaterial(sg)
	Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_LINK)
end
--
function c1156015.con2(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
--
function c1156015.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
--
function c1156015.op2(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		if Duel.MoveToField(re:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEDOWN,true) then
			Duel.ConfirmCards(1-tp,re:GetHandler())
			Duel.RaiseEvent(re:GetHandler(),EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
			re:GetHandler():CancelToGrave()
		end
	end
end
--
function c1156015.vfilter3(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c1156015.value3(e,c)
	local g=Duel.GetMatchingGroup(c1156015.vfilter3,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local ct=g:GetCount()
	return ct*200
end
--
function c1156015.tfilter4_1(c,e)
	return c:GetEquipTarget(e:GetHandler()) and c:IsAbleToGrave()
end
function c1156015.tfilter4_2(c)
	return c:IsType(TYPE_EQUIP) and c:IsType(TYPE_SPELL) and c:IsAbleToRemove()
end
function c1156015.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c1156015.tfilter4_1,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e) or Duel.IsExistingMatchingCard(c1156015.tfilter4_2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(1156015,3)) then
		if Duel.IsExistingMatchingCard(c1156015.tfilter4_1,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e) and Duel.IsExistingMatchingCard(c1156015.tfilter4_2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) then
			local sel=Duel.SelectOption(tp,aux.Stringid(1156015,1),aux.Stringid(1156015,2))
			if sel==0 then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1156015,1))
				local g=Duel.SelectMatchingCard(tp,c1156015.tfilter4_1,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,e)
				if g:GetCount()>0 then
					Duel.SendtoGrave(g,REASON_EFFECT)
				end
				return true
			else
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1156015,2))
				local g=Duel.SelectMatchingCard(tp,c1156015.tfilter4_2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
				if g:GetCount()>0 then
					Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
				end
				return true
			end
		else
			if Duel.IsExistingMatchingCard(c1156015.tfilter4_1,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e) and not Duel.IsExistingMatchingCard(c1156015.tfilter4_2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1156015,1))
				local g=Duel.SelectMatchingCard(tp,c1156015.tfilter4_1,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,e)
				if g:GetCount()>0 then
					Duel.SendtoGrave(g,REASON_EFFECT)
				end
				return true
			else
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1156015,2))
				local g=Duel.SelectMatchingCard(tp,c1156015.tfilter4_2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
				if g:GetCount()>0 then
					Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
				end 
				return true
			end
		end
	else
		return false
	end
end
--
