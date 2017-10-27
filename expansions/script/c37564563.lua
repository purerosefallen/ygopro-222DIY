--Nanahira & Tsubaki
local m=37564563
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	Senya.Nanahira(c)
	Senya.AddSummonMusic(c,aux.Stringid(m,3),SUMMON_TYPE_ADVANCE)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(cm.otcon)
	e1:SetOperation(cm.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetTarget(cm.sumtg)
	e4:SetOperation(cm.sumop)
	c:RegisterEffect(e4)
	Senya.NegateEffectModule(c,1,nil,nil,function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) end)
end
function cm.otfilter(c)
	return c:IsType(TYPE_COUNTER) and c:IsReleasable()
end
function cm.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(cm.otfilter,tp,LOCATION_SZONE,0,nil)
	return c:GetLevel()>6 and minc<=2
		and (Duel.GetMZoneCount(tp)>0 and mg:GetCount()>=2
			or Duel.CheckTribute(c,1) and mg:GetCount()>=1)
		or c:GetLevel()>4 and c:GetLevel()<=6 and minc<=1
			and Duel.GetMZoneCount(tp)>0 and mg:GetCount()>=1
end
function cm.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(cm.otfilter,tp,LOCATION_SZONE,0,nil)
	local b1=Duel.GetMZoneCount(tp)>0 and mg:GetCount()>=2
	local b2=Duel.CheckTribute(c,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=mg:Select(tp,1,1,nil)
	if c:GetLevel()>6 then
		local g2=nil
		if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(m,1))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			g2=mg:Select(tp,1,1,g:GetFirst())
		else
			g2=Duel.SelectTribute(tp,c,1,1)
		end
		g:Merge(g2)
	end
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local pos=0
	if c:IsSummonable(true,nil,1) then pos=pos+POS_FACEUP_ATTACK end
	if c:IsMSetable(true,nil,1) then pos=pos+POS_FACEDOWN_DEFENSE end
	if pos==0 then return end
	if Duel.SelectPosition(tp,c,pos)==POS_FACEUP_ATTACK then
		Duel.Summon(tp,c,true,nil,1)
	else
		Duel.MSet(tp,c,true,nil,1)
	end
end