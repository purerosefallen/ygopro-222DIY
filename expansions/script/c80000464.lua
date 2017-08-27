--ＬＰＭ 捷克罗姆
function c80000464.initial_effect(c)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	--xyz summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c80000464.xyzcon)
	e1:SetOperation(c80000464.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--wudi 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c80000464.efilter)
	c:RegisterEffect(e2) 
	--cannot disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCondition(c80000464.effcon)
	c:RegisterEffect(e3)
	--spsummon limit
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(c80000464.splimit)
	c:RegisterEffect(e4)	
	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80000464,0))
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c80000464.cost)
	e5:SetTarget(c80000464.target)
	e5:SetOperation(c80000464.operation)
	c:RegisterEffect(e5) 
	--damage
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DAMAGE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCountLimit(1,80000464+EFFECT_COUNT_CODE_DUEL)
	e6:SetCondition(c80000464.damcon)
	e6:SetTarget(c80000464.damtg)
	e6:SetOperation(c80000464.damop)
	c:RegisterEffect(e6)
	--spsummon limit
	local e8=Effect.CreateEffect(c)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_SPSUMMON_CONDITION)
	e8:SetValue(c80000464.splimit)
	c:RegisterEffect(e8)
	if not c80000464.xyz_filter then
		c80000464.xyz_filter=function(mc) return mc:IsType(TYPE_XYZ) and mc:IsRace(RACE_THUNDER) and mc:IsCanBeXyzMaterial(c) end
	end
end 
function c80000464.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ and not (se:GetHandler():IsType(TYPE_SPELL) or se:GetHandler():IsType(TYPE_MONSTER) or se:GetHandler():IsType(TYPE_TRAP))
end  
function c80000464.mfilter(c,xyzc)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRace(RACE_THUNDER) and c:IsCanBeXyzMaterial(xyzc)
end
function c80000464.xyzfilter1(c,g,ct)
	return g:IsExists(c80000464.xyzfilter2,ct,c,c:GetRank())
end
function c80000464.xyzfilter2(c,rk)
	return c:GetRank()==rk
end
function c80000464.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local minc=5
	local maxc=64
	if min then
		minc=math.max(minc,min)
		maxc=max
	end
	local ct=math.max(minc-1,-ft)
	local mg=nil
	if og then
		mg=og:Filter(c80000464.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c80000464.mfilter,tp,LOCATION_MZONE,0,nil,c)
	end
	return maxc>=5 and mg:IsExists(c80000464.xyzfilter1,1,nil,mg,ct)
end
function c80000464.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local g=nil
	if og and not min then
		g=og
	else
		local mg=nil
		if og then
			mg=og:Filter(c80000464.mfilter,nil,c)
		else
			mg=Duel.GetMatchingGroup(c80000464.mfilter,tp,LOCATION_MZONE,0,nil,c)
		end
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local minc=5
		local maxc=64
		if min then
			minc=math.max(minc,min)
			maxc=max
		end
		local ct=math.max(minc-1,-ft)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=mg:FilterSelect(tp,c80000464.xyzfilter1,1,1,nil,mg,ct)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g2=mg:FilterSelect(tp,c80000464.xyzfilter2,ct,maxc-1,g:GetFirst(),g:GetFirst():GetRank())
		g:Merge(g2)
	end
	local sg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		sg:Merge(tc:GetOverlayGroup())
		tc=g:GetNext()
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end
function c80000464.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end 
function c80000464.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80000464.effcon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c80000464.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0  end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c80000464.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2000)
end
function c80000464.operation(e,tp,eg,ep,ev,re,r,rp)  
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c80000464.actlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c80000464.actlimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c80000464.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and re:GetHandler():IsCode(80000463)
end
function c80000464.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(8000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,8000)
	Duel.SetChainLimit(aux.FALSE)
end
function c80000464.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end